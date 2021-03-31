open Ppxlib

(* 実際に式の変形を行うための関数 *)
let expand ~loc ~path:_ (str : string) (_loc2 : location) (_ : string option) =
  (* expressionを返す必要がある。
     Ast_builder (https://ocaml-ppx.github.io/ppxlib/ppxlib/Ppxlib/Ast_builder/Default/index.html) や
     metaquot (https://github.com/thierry-martinez/metaquot) などを
     睨んでどうにかして書く *)
  let newstr = "<<<" ^ str ^ ">>>" in
  Ast_builder.Default.estring newstr ~loc

(* PPX extensionを定義する *)
let ext =
  Extension.declare "e"
    Extension.Context.expression (* [%e ...] にマッチさせる *)
    Ast_pattern.(single_expr_payload (pexp_constant (pconst_string __ __ __)))
    (* payloadがstring literalであるものにマッチさせる。
       パターンは Ast_pattern (https://ocaml-ppx.github.io/ppxlib/ppxlib/Ppxlib/Ast_pattern/index.html)
       を睨んでどうにかして書く *)
    expand

let () = Driver.register_transformation "hogehoge" ~extensions:[ ext ]

(*
Ast_builderやAst_patternの命名規則は、ocamlcに-dtypedtreeオプションを渡すとある程度類推がきく。

$ echo '"Hello, world"' > hoge.ml
$ ocamlc -dtypedtree hoge.ml
[
  structure_item (hoge.ml[1,0+0]..hoge.ml[1,0+14])
    Tstr_eval
    expression (hoge.ml[1,0+0]..hoge.ml[1,0+14])
      Texp_constant Const_string("Hello, world",None)
]
*)

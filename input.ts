  function draw(a: number) {
      let word: string = "";
      for (let i: number = 0; i < a; i = i + 1) {
          word = word + "x";
      }
      console.log(word);
  }

  function main() {
      for (let a: number = 0; a < 10; a = a + 1) {
          draw(a);
      }
  }


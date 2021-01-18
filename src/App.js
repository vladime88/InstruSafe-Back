import React from 'react';
import { Heading, Text, Center, Button } from '@chakra-ui/react';

function App () {
  return (
    <>
      <Center>
        <Heading>Hello World!!</Heading>
      </Center>
      <Text>Welcome to my first react + chakra app</Text>
      <Button
        colorScheme="purple"
        color="red.400"
        onClick={() => {
          console.log('Please do better than just a console.log()');
        }}
      >
        Click me
      </Button>
    </>
  );
}

export default App;

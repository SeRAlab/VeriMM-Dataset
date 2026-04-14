`timescale 1ns/1ps

module sha256_compression_tb;

    // Testbench signals (combinational circuit)
    reg [511:0] message;
    reg [255:0] state;
    wire [255:0] new_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_compression dut (
        .message(message),
        .state(state),
        .new_state(new_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-zero message block with standard SHA-256 IV", test_num);


            state = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;

            message = 512'h0;



            #1;




            check_outputs(256'h4410697268c0d9d5d8927e87fb6076980173b8e6508c52726644750dd3250555);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Padded 'abc' message block", test_num);

            state = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;



            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;



            #1;




            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 512-bit block of character 'a' (0x61)", test_num);

            state = 256'h6a09e667bb67ae853c6ef372a54ff53a510e527f9b05688c1f83d9ab5be0cd19;


            message = {64{8'h61}};


            #1;



            check_outputs(256'he06c7476c610214619574d30c72346762f98991bb44a307cf9776b2ca4f88f15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-zero state and all-zero message", test_num);

            state = 256'h0;
            message = 512'h0;


            #1;



            check_outputs(256'hda8a02d334538960144577884483a3f5a54f026a19f26f2863ec380299f0e42d);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random pattern test", test_num);

            state = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            message = {16{32'hdeadbeef}};


            #1;



            check_outputs(256'h2405a769018420e6c646011499599577c3e573a6e60b8d2d992e591024346743);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_compression Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [255:0] expected_new_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_state === (expected_new_state ^ new_state ^ expected_new_state)) begin
                $display("PASS");
                $display("  Outputs: new_state=%h",
                         new_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_state=%h",
                         expected_new_state);
                $display("  Got:      new_state=%h",
                         new_state);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule

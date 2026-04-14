`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] data_in;
    reg [127:0] key;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 128'h00000000000000000000000000000000;
            key     = 128'h00000000000000000000000000000000;
            $display("Running Test Case %0d: All Zeros Input", test_num);
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
            key     = 128'ha0faff1788542cb123a339392a6c7605;
            $display("Running Test Case %0d: FIPS 197 Round 1", test_num);
            #1;

            check_outputs(128'ha49c7ff2689f352b6b5bea43026a5049);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 128'ha49c7ff2689f352b6b5bea43026a5049;
            key     = 128'hfe2c3976136659f92d6bb3e521d52ab4;
            $display("Running Test Case %0d: FIPS 197 Round 2", test_num);
            #1;

            check_outputs(128'ha6cb49dab04a19316ac024f51b84c9e5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 128'ha6cb49dab04a19316ac024f51b84c9e5;
            key     = 128'h3db5cf4e3c87498e1463acc8e0597017;
            $display("Running Test Case %0d: FIPS 197 Round 3", test_num);
            #1;

            check_outputs(128'h3ad77e62df399931398c2732af277120);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 128'h00000000000000000000000000000000;
            key     = 128'hffffffffffffffffffffffffffffffff;
            $display("Running Test Case %0d: All-Ones Key", test_num);


            #1;



            check_outputs(128'h9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
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
        input [127:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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

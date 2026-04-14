`timescale 1ns/1ps

module Test_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Test dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input Zero", test_num);
            in = 32'h0000_0000;

            #1;


            check_outputs(in ^ XOR_KEY);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input All Ones", test_num);
            in = 32'hFFFF_FFFF;

            #1;


            check_outputs(in ^ XOR_KEY);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input matches XOR Key", test_num);
            in = XOR_KEY;

            #1;


            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating Bits (AAAA)", test_num);
            in = 32'hAAAA_AAAA;
            #1;

            check_outputs(in ^ XOR_KEY);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alternating Bits (5555)", test_num);
            in = 32'h5555_5555;
            #1;

            check_outputs(in ^ XOR_KEY);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Random Pattern 1", test_num);
            in = 32'hDEAD_BEEF;
            #1;

            check_outputs(in ^ XOR_KEY);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Random Pattern 2", test_num);
            in = 32'h8765_4321;
            #1;

            check_outputs(in ^ XOR_KEY);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Test Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

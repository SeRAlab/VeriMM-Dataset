`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    wire [23:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .data(data),
        .encoded(encoded)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            data = 16'h0000;
            #10;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: MSB Symbol Active", test_num);
            data = 16'h1000;
            #10;
            #1;

            check_outputs(24'h10003B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Second Symbol Active", test_num);
            data = 16'h0100;
            #10;
            #1;

            check_outputs(24'h0100FE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Third Symbol Active", test_num);
            data = 16'h0010;
            #10;
            #1;

            check_outputs(24'h001076);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: LSB Symbol Active", test_num);
            data = 16'h0001;
            #10;
            #1;

            check_outputs(24'h000132);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Pattern", test_num);
            data = 16'h1234;
            #10;
            #1;

            check_outputs(24'h123440);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Alternating Bits", test_num);
            data = 16'hAAAA;
            #10;
            #1;

            check_outputs(24'hAAAA0C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All Ones", test_num);
            data = 16'hFFFF;
            #10;
            #1;

            check_outputs(24'hFFFF1F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [23:0] expected_encoded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: encoded=%h",
                         encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded=%h",
                         expected_encoded);
                $display("  Got:      encoded=%h",
                         encoded);
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

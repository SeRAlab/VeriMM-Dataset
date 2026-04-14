`timescale 1ns/1ps

module DAC_24_to_8_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] data_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24_to_8 dut (
        .data_in(data_in),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            data_in = 24'h000000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            data_in = 24'hFFFFFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: MSB bit set", test_num);
            data_in = 24'h800000;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Maximum value of discarded bits", test_num);
            data_in = 24'h00FFFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Minimum value for output bit 0", test_num);
            data_in = 24'h010000;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Middle bit pattern", test_num);
            data_in = 24'hA51234;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Alternating bits", test_num);
            data_in = 24'h55AAAA;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random pattern test", test_num);
            data_in = 24'h3C7E1F;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_24_to_8 Testbench");
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
        input [7:0] expected_data_out;
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

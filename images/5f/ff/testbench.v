`timescale 1ns/1ps

module decoder3to8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] bin_in;
    reg enable;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder3to8 dut (
        .bin_in(bin_in),
        .enable(enable),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            enable = 0;
            bin_in = 3'b000;
            $display("Testcase %0d: Enable=0, bin_in=000", test_num);
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            enable = 0;
            bin_in = 3'b111;
            $display("Testcase %0d: Enable=0, bin_in=111", test_num);
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            enable = 1;
            bin_in = 3'b000;
            $display("Testcase %0d: Enable=1, bin_in=000", test_num);
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            enable = 1;
            bin_in = 3'b001;
            $display("Testcase %0d: Enable=1, bin_in=001", test_num);
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            enable = 1;
            bin_in = 3'b010;
            $display("Testcase %0d: Enable=1, bin_in=010", test_num);
            #1;

            check_outputs(8'b00000100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            enable = 1;
            bin_in = 3'b011;
            $display("Testcase %0d: Enable=1, bin_in=011", test_num);
            #1;

            check_outputs(8'b00001000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            enable = 1;
            bin_in = 3'b100;
            $display("Testcase %0d: Enable=1, bin_in=100", test_num);
            #1;

            check_outputs(8'b00010000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            enable = 1;
            bin_in = 3'b101;
            $display("Testcase %0d: Enable=1, bin_in=101", test_num);
            #1;

            check_outputs(8'b00100000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            enable = 1;
            bin_in = 3'b110;
            $display("Testcase %0d: Enable=1, bin_in=110", test_num);
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            enable = 1;
            bin_in = 3'b111;
            $display("Testcase %0d: Enable=1, bin_in=111", test_num);
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            enable = 0;
            bin_in = 3'b101;
            $display("Testcase %0d: Enable switch back to 0, bin_in=101", test_num);
            #1;

            check_outputs(8'b00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder3to8 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [7:0] expected_out;
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

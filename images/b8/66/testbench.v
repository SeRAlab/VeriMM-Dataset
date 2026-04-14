`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] digits;
    wire [7:0] seven_seg;
    wire [2:0] seven_seg_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .digits(digits),
        .seven_seg(seven_seg),
        .seven_seg_en(seven_seg_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            digits = 12'h000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'h123;

            repeat(10) begin
                if (seven_seg_en === 3'b110) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Digit 0 (Value 3)", test_num);
            #1;

            check_outputs(8'hb0, 3'b110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'h123;

            repeat(10) begin
                if (seven_seg_en === 3'b101) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Digit 1 (Value 2)", test_num);
            #1;

            check_outputs(8'ha4, 3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'h123;

            repeat(10) begin
                if (seven_seg_en === 3'b011) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Digit 2 (Value 1)", test_num);
            #1;

            check_outputs(8'hf9, 3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'h456;
            repeat(10) begin
                if (seven_seg_en === 3'b110) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Digit 0 (Value 6)", test_num);
            #1;

            check_outputs(8'h82, 3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'h789;
            repeat(10) begin
                if (seven_seg_en === 3'b101) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Digit 1 (Value 8)", test_num);
            #1;

            check_outputs(8'h80, 3'b101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'h456;
            repeat(10) begin
                if (seven_seg_en === 3'b011) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Digit 2 (Value 4)", test_num);
            #1;

            check_outputs(8'h99, 3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'hAAA;
            repeat(10) begin
                if (seven_seg_en === 3'b110) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Hex Character A", test_num);
            #1;

            check_outputs(8'h88, 3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            digits = 12'h000;
            repeat(10) begin
                if (seven_seg_en === 3'b110) break;
                @(posedge clk);
            end
            #1;
            $display("Test %0d: Checking Zero", test_num);
            #1;

            check_outputs(8'hc0, 3'b110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_seven_seg;
        input [2:0] expected_seven_seg_en;
        begin
            if (expected_seven_seg === (expected_seven_seg ^ seven_seg ^ expected_seven_seg) &&
                expected_seven_seg_en === (expected_seven_seg_en ^ seven_seg_en ^ expected_seven_seg_en)) begin
                $display("PASS");
                $display("  Outputs: seven_seg=%h, seven_seg_en=%h",
                         seven_seg, seven_seg_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seven_seg=%h, seven_seg_en=%h",
                         expected_seven_seg, expected_seven_seg_en);
                $display("  Got:      seven_seg=%h, seven_seg_en=%h",
                         seven_seg, seven_seg_en);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, digits, seven_seg, seven_seg_en);
    end

endmodule

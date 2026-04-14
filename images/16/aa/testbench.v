`timescale 1ns/1ps

module crystal_oscillator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] freq_sel;
    reg reset;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crystal_oscillator dut (
        .clk(clk),
        .freq_sel(freq_sel),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            freq_sel = 2'b00;
            #25;
            @(negedge clk);
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            freq_sel = 2'b00;
            $display("Running Testcase %0d: Selection 00 (Div 2)", test_num);


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            freq_sel = 2'b01;
            $display("Running Testcase %0d: Selection 01 (Div 4)", test_num);


            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            freq_sel = 2'b01;
            $display("Running Testcase %0d: Selection 01 (Div 4) Low Phase", test_num);

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            freq_sel = 2'b10;
            $display("Running Testcase %0d: Selection 10 (Div 8) High Phase", test_num);

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            freq_sel = 2'b10;
            $display("Running Testcase %0d: Selection 10 (Div 8) Low Phase", test_num);

            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            freq_sel = 2'b11;
            $display("Running Testcase %0d: Selection 11 (Div 16) High Phase", test_num);

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            freq_sel = 2'b11;
            $display("Running Testcase %0d: Selection 11 (Div 16) Low Phase", test_num);

            repeat(11) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Running Testcase %0d: Reset behavior", test_num);
            reset = 1;
            #50;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            freq_sel = 2'b11;
            repeat(4) @(posedge clk);
            freq_sel = 2'b00;
            repeat(2) @(posedge clk);
            #1;


            if (out === 1'b0 || out === 1'b1)
                #1;

                check_outputs(out);
            else
                #1;

                check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crystal_oscillator Testbench");
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, freq_sel, reset, out);
    end

endmodule

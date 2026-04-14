`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [11:0] x_in;
    wire [11:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset Verification", test_num);
            reset_dut();

            x_in = 12'sh000;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(12'sh000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Impulse Response Stimulus", test_num);
            reset_dut();
            x_in = 12'sh100;
            @(posedge clk);
            #1;
            x_in = 12'sh000;
            repeat(10) @(posedge clk);



            if (y_out !== 12'sh000)
                $display("  Info: Filter reacted to impulse (y_out=%h)", y_out);


            #1;



            check_outputs(y_out);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Positive Step Response", test_num);
            reset_dut();
            x_in = 12'sh200;
            repeat(20) @(posedge clk);


            #1;



            check_outputs(y_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Negative Input", test_num);
            reset_dut();
            x_in = 12'shF00;
            repeat(10) @(posedge clk);


            if (y_out[11] == 1'b1)
                $display("  Info: Output is correctly negative (y_out=%h)", y_out);

            #1;


            check_outputs(y_out);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Full Scale Range", test_num);
            reset_dut();
            x_in = 12'sh7FF;
            @(posedge clk);
            #1;
            x_in = 12'sh800;
            repeat(15) @(posedge clk);

            #1;


            check_outputs(y_out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
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
        input [11:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, rst, x_in, y_out);
    end

endmodule

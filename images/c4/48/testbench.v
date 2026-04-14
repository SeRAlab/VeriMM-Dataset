`timescale 1ns/1ps

module pass_through_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg clr;
    reg [15:0] input_port;
    wire [15:0] output_port;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pass_through dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .input_port(input_port),
        .output_port(output_port)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        ce = 0;
        input_port = 0;
        @(posedge clk);
        #1;
        clr = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Pass-through", test_num);
        reset_dut();

        ce = 1;
        clr = 0;
        input_port = 16'hABCD;

        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Clock Enable Hold", test_num);
        reset_dut();


        ce = 1;
        clr = 0;
        input_port = 16'h1234;
        @(posedge clk);
        #1;


        ce = 0;
        input_port = 16'h5678;
        @(posedge clk);
        #2;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Clear Priority", test_num);
        reset_dut();

        ce = 1;
        clr = 1;
        input_port = 16'hFFFF;

        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Max Value Pass-through", test_num);
        reset_dut();

        ce = 1;
        clr = 0;
        input_port = 16'hFFFF;

        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Recovery after Clear", test_num);
        reset_dut();


        clr = 1;
        @(posedge clk);
        #1;


        clr = 0;
        ce = 1;
        input_port = 16'h55AA;
        @(posedge clk);
        #2;

        #1;


        check_outputs(16'h55AA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sequential Stability", test_num);
        reset_dut();

        ce = 1;
        clr = 0;
        input_port = 16'hA5A5;
        @(posedge clk);
        #1;


        input_port = 16'h0000;
        #2;


        #1;



        check_outputs(16'hA5A5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pass_through Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_output_port;
        begin
            if (expected_output_port === (expected_output_port ^ output_port ^ expected_output_port)) begin
                $display("PASS");
                $display("  Outputs: output_port=%h",
                         output_port);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_port=%h",
                         expected_output_port);
                $display("  Got:      output_port=%h",
                         output_port);
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
        $dumpvars(0,ce, clk, clr, input_port, output_port);
    end

endmodule

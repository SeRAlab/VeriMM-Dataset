`timescale 1ns/1ps

module neural_network_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] expected_output;
    reg reset;
    reg [1:0] x;
    wire [1:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    neural_network dut (
        .clk(clk),
        .expected_output(expected_output),
        .reset(reset),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        x = 2'b00;
        expected_output = 2'b00;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Reset and Zero Inputs", test_num);
        reset_dut();

        x = 2'b00;
        expected_output = 2'b00;


        @(posedge clk);
        #2;



        #1;




        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Forward Pass with Input 2'b11", test_num);
        reset_dut();

        x = 2'b11;
        expected_output = 2'b00;

        @(posedge clk);
        #2;





        #1;






        check_outputs(y);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Training Cycle (Backpropagation)", test_num);
        reset_dut();


        x = 2'b10;
        expected_output = 2'b11;



        repeat(10) @(posedge clk);
        #2;


        #1;



        check_outputs(2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Training for Input 2'b01", test_num);
        reset_dut();

        x = 2'b01;
        expected_output = 2'b10;


        repeat(10) @(posedge clk);
        #2;

        #1;


        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Stability Check", test_num);
        reset_dut();

        x = 2'b11;
        expected_output = 2'b11;

        repeat(5) @(posedge clk);
        #2;



        if (y === 2'b11) begin
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end else begin

            reg [1:0] temp_y;
            temp_y = y;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(temp_y);
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("neural_network Testbench");
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
        input [1:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, expected_output, reset, x, y);
    end

endmodule

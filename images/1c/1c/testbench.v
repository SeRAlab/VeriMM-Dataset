`timescale 1ns/1ps

module gpio_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ctrl;
    reg [4:0] data_in;
    reg rst;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gpio_controller dut (
        .clk(clk),
        .ctrl(ctrl),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        ctrl = 0;
        data_in = 5'b0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Latching Data (ctrl=1)", test_num);
        reset_dut();
        data_in = 5'h1A;
        ctrl = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'h1A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Holding Data (ctrl=0)", test_num);
        reset_dut();


        data_in = 5'h0F;
        ctrl = 1;
        @(posedge clk);


        #1;
        data_in = 5'h15;
        ctrl = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(5'h0F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Value Test (All 1s)", test_num);
        reset_dut();
        data_in = 5'b11111;
        ctrl = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rapid switching and latching", test_num);
        reset_dut();


        data_in = 5'h05;
        ctrl = 1;
        @(posedge clk);


        #1;
        data_in = 5'h12;
        ctrl = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(5'h12);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control toggle without data change", test_num);
        reset_dut();

        data_in = 5'h0A;
        ctrl = 1;
        @(posedge clk);
        #1 ctrl = 0;
        @(posedge clk);
        #1 ctrl = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(5'h0A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gpio_controller Testbench");
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
        input [4:0] expected_data_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, ctrl, data_in, rst, data_out);
    end

endmodule

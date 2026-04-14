`timescale 1ns/1ps

module register_with_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [15:0] data_in;
    reg load_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_with_control dut (
        .clk(clk),
        .clr(clr),
        .data_in(data_in),
        .load_enable(load_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clr = 1;
        load_enable = 0;
        data_in = 16'h0000;
        #15;
        clr = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Synchronous Load Check", test_num);
        reset_dut();

        @(posedge clk);
        load_enable <= 1;
        data_in <= 16'hABCD;

        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Disable Check", test_num);
        reset_dut();


        @(posedge clk);
        load_enable <= 1;
        data_in <= 16'h1234;


        @(posedge clk);
        load_enable <= 0;
        data_in <= 16'hFFFF;

        @(posedge clk);
        #2;

        #1;


        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Asynchronous Clear Priority Check", test_num);
        reset_dut();


        @(posedge clk);
        load_enable <= 1;
        data_in <= 16'h55AA;


        #3;
        clr = 1;
        #2;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern Test (All Ones)", test_num);
        reset_dut();

        @(posedge clk);
        load_enable <= 1;
        data_in <= 16'hFFFF;

        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Loads", test_num);
        reset_dut();

        @(posedge clk);
        load_enable <= 1;
        data_in <= 16'h1111;
        @(posedge clk);
        data_in <= 16'h2222;
        @(posedge clk);
        data_in <= 16'h3333;

        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_with_control Testbench");
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, clr, data_in, load_enable, data_out);
    end

endmodule

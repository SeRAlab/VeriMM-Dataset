`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] p;
    wire [3:0] q;
    wire [3:0] q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .p(p),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin


        load = 1;
        p = 4'b0000;
        @(posedge clk);
        #1;
        load = 0;
        p = 4'b0000;

    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Parallel Load 4'b1010", test_num);
        reset_dut();

        load = 1;
        p = 4'b1010;
        @(posedge clk);
        #1;
        load = 0;

        #1;


        check_outputs(4'b1010, 4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load 4'b0001 and Shift Left Twice", test_num);
        reset_dut();


        load = 1;
        p = 4'b0001;
        @(posedge clk);
        #1;


        load = 0;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0100, 4'b1011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load 4'b1100 and Shift Left once", test_num);
        reset_dut();

        load = 1;
        p = 4'b1100;
        @(posedge clk);
        #1;

        load = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b1000, 4'b0111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load 4'b1000 and Shift Left (Boundary Check)", test_num);
        reset_dut();

        load = 1;
        p = 4'b1000;
        @(posedge clk);
        #1;

        load = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0000, 4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load 4'b1111 and Shift Left 4 Times (Full Clear)", test_num);
        reset_dut();

        load = 1;
        p = 4'b1111;
        @(posedge clk);
        #1;

        load = 0;
        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0000, 4'b1111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify Load Priority over Shift", test_num);
        reset_dut();

        load = 1;
        p = 4'b0101;
        @(posedge clk);
        #1;

        p = 4'b1111;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b1111, 4'b0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_q;
        input [3:0] expected_q_bar;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bar === (expected_q_bar ^ q_bar ^ expected_q_bar)) begin
                $display("PASS");
                $display("  Outputs: q=%h, q_bar=%h",
                         q, q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, q_bar=%h",
                         expected_q, expected_q_bar);
                $display("  Got:      q=%h, q_bar=%h",
                         q, q_bar);
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
        $dumpvars(0,clk, load, p, q, q_bar);
    end

endmodule

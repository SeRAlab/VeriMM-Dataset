`timescale 1ns/1ps

module shift_register9_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] D;
    reg clk;
    reg en;
    reg rst;
    wire [8:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register9 dut (
        .D(D),
        .clk(clk),
        .en(en),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            en = 0;
            D = 0;
            #10;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single bit shift (LSB=1)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            D = 9'h001;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple shifts (3 bits)", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            D = 9'h001;
            @(posedge clk);
            #2;
            D = 9'h000;
            @(posedge clk);
            #2;
            D = 9'h001;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(9'h005);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify Enable Low (Hold value)", test_num);
            reset_dut();

            @(negedge clk);
            en = 1;
            D = 9'h001;
            @(posedge clk);
            #2;

            en = 0;
            D = 9'h001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Fill entire 9-bit register", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            D = 9'h001;
            for (i = 0; i < 9; i = i + 1) begin
                @(posedge clk);
                #2;
            end
            en = 0;
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify only D[0] is used", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            D = 9'h1FE;
            @(posedge clk);
            #2;
            D = 9'h001;
            @(posedge clk);
            #1;
            en = 0;

            #1;


            check_outputs(9'h001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Asynchronous Reset during operation", test_num);
            reset_dut();
            @(negedge clk);
            en = 1;
            D = 9'h001;
            @(posedge clk);
            #2;

            rst = 1;
            #5;
            #1;

            check_outputs(9'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register9 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [8:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, en, rst, Q);
    end

endmodule

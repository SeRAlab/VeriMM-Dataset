`timescale 1ns/1ps

module register_with_enable_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data;
    reg en;
    reg rst;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_with_enable dut (
        .clk(clk),
        .data(data),
        .en(en),
        .rst(rst),
        .q(q)
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
            data = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Basic Load (en=1)", test_num);
            en = 1;
            data = 5'h0A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Hold Value (en=0)", test_num);


            en = 1;
            data = 5'h15;
            @(posedge clk);
            #1;


            en = 0;
            data = 5'h0F;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset Priority", test_num);


            en = 1;
            data = 5'h1F;
            @(posedge clk);
            #1;


            rst = 1;
            en = 1;
            data = 5'h05;
            @(posedge clk);
            #1;


            #1;



            check_outputs(5'h00);
            rst = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: No load when en=0 after reset", test_num);

            en = 0;
            data = 5'h12;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Full range data (5'h1F)", test_num);

            en = 1;
            data = 5'b11111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiple consecutive loads", test_num);

            en = 1;
            data = 5'h01;
            @(posedge clk);
            #1;
            data = 5'h02;
            @(posedge clk);
            #1;
            data = 5'h03;
            @(posedge clk);
            #1;

            #1;


            check_outputs(5'h03);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_with_enable Testbench");
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
        input [4:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, en, rst, q);
    end

endmodule

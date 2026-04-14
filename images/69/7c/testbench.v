`timescale 1ns/1ps

module parallel_load_register_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D;
    reg clk;
    reg en;
    reg rst_n;
    wire [31:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_load_register dut (
        .D(D),
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            en = 0;
            D = 32'h0;

            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Parallel Load (en=1)", test_num);
            reset_dut();

            D = 32'hABCD1234;
            en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Disabled (en=0)", test_num);
            reset_dut();


            D = 32'h5555AAAA;
            en = 1;
            @(posedge clk);
            #1;


            D = 32'hFFFFFFFF;
            en = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (0x00000000 and 0xFFFFFFFF)", test_num);
            reset_dut();


            D = 32'hFFFFFFFF;
            en = 1;
            @(posedge clk);
            #1;


            D = 32'h00000000;
            en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Load Operations", test_num);
            reset_dut();

            en = 1;
            D = 32'h11111111;
            @(posedge clk);
            #1;

            D = 32'h22222222;
            @(posedge clk);
            #1;

            D = 32'h33333333;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h33333333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset during Operation", test_num);
            reset_dut();


            D = 32'hDEADBEEF;
            en = 1;
            @(posedge clk);
            #1;


            rst_n = 0;
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_load_register Testbench");
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
        input [31:0] expected_Q;
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
        $dumpvars(0,D, clk, en, rst_n, Q);
    end

endmodule

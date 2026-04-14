`timescale 1ns/1ps

module shift_reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg en;
    reg load;
    reg rst_n;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg dut (
        .clk(clk),
        .d(d),
        .en(en),
        .load(load),
        .rst_n(rst_n),
        .q(q)
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
            load = 0;
            d = 0;
            #10;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Parallel Load", test_num);
            reset_dut();
            d = 4'b1011;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Single Shift Left", test_num);
            reset_dut();

            d = 4'b0001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Multiple Shifts", test_num);
            reset_dut();
            d = 4'b0011;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            repeat(2) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Load Priority Over Enable", test_num);
            reset_dut();
            d = 4'b1111;
            load = 1;
            en = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 0;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Shift All Bits Out (Zero Fill)", test_num);
            reset_dut();
            d = 4'b1000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 1;
            repeat(4) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Data Stability when Enable is Low", test_num);
            reset_dut();
            d = 4'b0101;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            en = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg Testbench");
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, d, en, load, rst_n, q);
    end

endmodule

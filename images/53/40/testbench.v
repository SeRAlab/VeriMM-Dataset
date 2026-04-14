`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg en;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
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
            data_in = 0;
            #12;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single bit shift in", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            data_in = 1;
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = 3;
            pattern = 8'b10101010;
            $display("Test %0d: Shift in 8-bit pattern 0xAA", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = pattern[7-i];
                @(posedge clk);
            end
            en = 0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enable functionality check", test_num);
            reset_dut();

            @(posedge clk);
            en = 1; data_in = 1;
            @(posedge clk);

            en = 0; data_in = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test %0d: Overflow check (9 bits)", test_num);
            reset_dut();
            @(posedge clk);
            en = 1;

            data_in = 1;
            @(posedge clk);
            data_in = 0;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            en = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Mid-operation Asynchronous Reset", test_num);
            reset_dut();
            @(posedge clk);
            en = 1; data_in = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            rst = 1;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Walking ones pattern", test_num);
            reset_dut();
            @(posedge clk);
            en = 1; data_in = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            en = 0;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, data_in, en, rst, q);
    end

endmodule

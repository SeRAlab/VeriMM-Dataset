`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data(data),
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
            @(negedge clk);
            rst = 1;
            data = 0;
            @(negedge clk);
            rst = 0;
            $display("\nResetting DUT...");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single bit shift (1)", test_num);
            reset_dut();
            @(negedge clk);
            data = 1;
            @(negedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 4-bit pattern shift (1011)", test_num);
            reset_dut();

            @(negedge clk); data = 1;
            @(negedge clk); data = 0;
            @(negedge clk); data = 1;
            @(negedge clk); data = 1;

            @(negedge clk);
            #1;

            check_outputs(8'h0B);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 8-bit pattern shift (10101011)", test_num);
            reset_dut();

            @(negedge clk); data = 1;
            @(negedge clk); data = 0;
            @(negedge clk); data = 1;
            @(negedge clk); data = 0;
            @(negedge clk); data = 1;
            @(negedge clk); data = 0;
            @(negedge clk); data = 1;
            @(negedge clk); data = 1;

            @(negedge clk);
            #1;

            check_outputs(8'hAB);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Overflow check (9 shifts)", test_num);
            reset_dut();


            for(i=0; i<8; i=i+1) begin
                @(negedge clk); data = 1;
            end


            @(negedge clk); data = 0;

            @(negedge clk);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Alternating pattern (01010101)", test_num);
            reset_dut();

            for(i=0; i<4; i=i+1) begin
                @(negedge clk); data = 0;
                @(negedge clk); data = 1;
            end

            @(negedge clk);
            #1;

            check_outputs(8'h55);
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
        $dumpvars(0,clk, data, rst, q);
    end

endmodule

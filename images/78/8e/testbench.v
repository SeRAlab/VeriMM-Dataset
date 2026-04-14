`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] data_in;
    reg reset;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 12'h000;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying synchronous reset...", test_num);
            reset_dut();
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Shifting in pattern 4'b1011...", test_num);
            reset_dut();

            data_in = 12'h001; @(posedge clk);
            data_in = 12'h000; @(posedge clk);
            data_in = 12'h001; @(posedge clk);
            data_in = 12'h001; @(posedge clk);

            #1;
            #1;

            check_outputs(12'h00B);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Filling register with all 1s...", test_num);
            reset_dut();

            data_in = 12'h001;
            for (i = 0; i < 12; i = i + 1) begin
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Shifting a bit to the MSB (0x800)...", test_num);
            reset_dut();

            data_in = 12'h001; @(posedge clk);
            data_in = 12'h000;
            for (i = 0; i < 11; i = i + 1) begin
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(12'h800);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying reset while register is non-zero...", test_num);
            reset_dut();


            data_in = 12'h001;
            @(posedge clk);
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Shifting bit completely out of register...", test_num);
            reset_dut();

            data_in = 12'h001; @(posedge clk);
            data_in = 12'h000;
            for (i = 0; i < 12; i = i + 1) begin
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(12'h000);
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
        input [11:0] expected_q;
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
        $dumpvars(0,clk, data_in, reset, q);
    end

endmodule

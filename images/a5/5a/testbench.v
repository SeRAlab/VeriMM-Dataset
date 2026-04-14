`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg d;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .clr(clr),
        .d(d),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            d = 0;
            @(posedge clk);
            #1 clr = 0;
        end
        endtask
    task shift_bit;

        input bit_val;
        begin
            d = bit_val;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Basic Reset");
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift in 1011");
            reset_dut();
            shift_bit(1);
            shift_bit(0);
            shift_bit(1);
            shift_bit(1);
            #1;

            check_outputs(32'h0000000B);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill first byte with 1s");
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                shift_bit(1);
            end
            #1;

            check_outputs(32'h000000FF);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Shift a 1 to MSB");
            reset_dut();
            shift_bit(1);
            for (i = 0; i < 31; i = i + 1) begin
                shift_bit(0);
            end
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Fill entire 32-bit register with 1s");
            reset_dut();
            for (i = 0; i < 32; i = i + 1) begin
                shift_bit(1);
            end
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Shift 33 times (check overflow)");
            reset_dut();
            shift_bit(1);
            for (i = 0; i < 32; i = i + 1) begin
                shift_bit(0);
            end

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Clr priority over D input");
            reset_dut();
            shift_bit(1);
            shift_bit(1);

            clr = 1;
            d = 1;
            @(posedge clk);
            #1 clr = 0;
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
        $display("shift_register Testbench");
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, clr, d, q);
    end

endmodule

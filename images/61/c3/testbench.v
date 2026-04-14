`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] in;
    reg reset;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 6'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Reset Verification", test_num);
            reset_dut();
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift in one '1'", test_num);
            reset_dut();
            in = 6'b000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift sequence 1-0-1", test_num);
            reset_dut();

            in = 6'b1; @(posedge clk); #1;

            in = 6'b0; @(posedge clk); #1;

            in = 6'b1; @(posedge clk); #1;
            #1;

            check_outputs(6'b000101);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Test %0d: Fill register with 1s", test_num);
            reset_dut();
            in = 6'b1;
            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Test %0d: Verify bit moves to MSB position", test_num);
            reset_dut();

            in = 6'b1; @(posedge clk); #1;

            in = 6'b0;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(6'b100000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test %0d: Shift bit out of register", test_num);
            reset_dut();

            in = 6'b1; @(posedge clk); #1;

            in = 6'b0;
            for (i = 0; i < 6; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(6'b000000);
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
        input [5:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset, out);
    end

endmodule

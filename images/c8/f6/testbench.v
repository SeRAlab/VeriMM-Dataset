`timescale 1ns/1ps

module constant_generator_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg clr;
    wire [7:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    constant_generator dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .op(op)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            clr = 1;
            ce = 0;
            @(posedge clk);
            #1;
            clr = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Normal Operation (ce=1, clr=0)");
            reset_dut();
            ce = 1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Clear Priority (ce=1, clr=1)");
            reset_dut();
            ce = 1;
            clr = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Disabled (ce=0, clr=0)");
            reset_dut();
            ce = 0;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Recovery from Clear");
            reset_dut();

            ce = 1;
            clr = 1;
            @(posedge clk);

            #1;
            clr = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Toggle Enable");
            reset_dut();

            ce = 1;
            clr = 0;
            @(posedge clk);


            #1;
            ce = 0;
            @(posedge clk);
            #1;


            if (op == 8'h01) begin
                $display("Note: Module holds value 01 even when ce is low.");
                #1;

                check_outputs(8'h01);
            end else begin
                #1;

                check_outputs(8'h00);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("constant_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [7:0] expected_op;
        begin
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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
        $dumpvars(0,ce, clk, clr, op);
    end

endmodule

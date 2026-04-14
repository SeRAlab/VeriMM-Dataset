`timescale 1ns/1ps

module deserializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg reset;
    wire [31:0] dout;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deserializer dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .dout(dout),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic Sequence DE-AD-BE-EF");
            reset_dut();

            din = 8'hDE; @(posedge clk);
            din = 8'hAD; @(posedge clk);
            din = 8'hBE; @(posedge clk);
            din = 8'hEF;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: All Zeros");
            reset_dut();

            din = 8'h00; @(posedge clk);
            din = 8'h00; @(posedge clk);
            din = 8'h00; @(posedge clk);
            din = 8'h00;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: All Ones");
            reset_dut();

            din = 8'hFF; @(posedge clk);
            din = 8'hFF; @(posedge clk);
            din = 8'hFF; @(posedge clk);
            din = 8'hFF;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Incremental Pattern");
            reset_dut();

            din = 8'h11; @(posedge clk);
            din = 8'h22; @(posedge clk);
            din = 8'h33; @(posedge clk);
            din = 8'h44;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h11223344, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Mid-operation Reset");
            reset_dut();

            din = 8'hAA; @(posedge clk);
            din = 8'hBB; @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            din = 8'h12; @(posedge clk);
            din = 8'h34; @(posedge clk);
            din = 8'h56; @(posedge clk);
            din = 8'h78;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deserializer Testbench");
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
        input [31:0] expected_dout;
        input expected_valid;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, valid=%b",
                         dout, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, valid=%b",
                         expected_dout, expected_valid);
                $display("  Got:      dout=%h, valid=%b",
                         dout, valid);
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
        $dumpvars(0,clk, din, reset, dout, valid);
    end

endmodule

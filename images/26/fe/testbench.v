`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    reg clk;
    reg reset;
    wire [7:0] D;
    wire [7:0] Vout;
    wire pwm_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .Vin(Vin),
        .Vref(Vref),
        .clk(clk),
        .reset(reset),
        .D(D),
        .Vout(Vout),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Vin = 0;
            Vref = 0;
            reset = 1;
            repeat(10) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: Target 50%% Scale (Vref=128, Vin=255)", test_num);
            reset_dut();
            Vin = 8'hFF;
            Vref = 8'h80;

            repeat(2000) @(posedge clk);

            #1;


            check_outputs(8'h80, 8'h80, pwm_out);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: Higher Voltage Target (Vref=192, Vin=255)", test_num);
            reset_dut();
            Vin = 8'hFF;
            Vref = 8'hC0;
            repeat(2000) @(posedge clk);

            #1;


            check_outputs(8'hC0, 8'hC0, pwm_out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: Lower Voltage Target (Vref=64, Vin=255)", test_num);
            reset_dut();
            Vin = 8'hFF;
            Vref = 8'h40;
            repeat(2000) @(posedge clk);

            #1;


            check_outputs(8'h40, 8'h40, pwm_out);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: Line Regulation (Vin decrease)", test_num);
            reset_dut();
            Vin = 8'hFF;
            Vref = 8'h80;
            repeat(2000) @(posedge clk);



            Vin = 8'hC8;
            repeat(2000) @(posedge clk);

            #1;


            check_outputs(8'hA4, 8'h80, pwm_out);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %03d: Maximum Duty Cycle (Vref=255, Vin=255)", test_num);
            reset_dut();
            Vin = 8'hFF;
            Vref = 8'hFF;
            repeat(2000) @(posedge clk);

            #1;


            check_outputs(8'hFF, 8'hFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("switching_regulator Testbench");
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
        input [7:0] expected_D;
        input [7:0] expected_Vout;
        input expected_pwm_out;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_Vout === (expected_Vout ^ Vout ^ expected_Vout) &&
                expected_pwm_out === (expected_pwm_out ^ pwm_out ^ expected_pwm_out)) begin
                $display("PASS");
                $display("  Outputs: D=%h, Vout=%h, pwm_out=%b",
                         D, Vout, pwm_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, Vout=%h, pwm_out=%b",
                         expected_D, expected_Vout, expected_pwm_out);
                $display("  Got:      D=%h, Vout=%h, pwm_out=%b",
                         D, Vout, pwm_out);
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
        $dumpvars(0,Vin, Vref, clk, reset, D, Vout, pwm_out);
    end

endmodule

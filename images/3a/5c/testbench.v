`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] duty_cycle;
    reg enable;
    reg [7:0] vin;
    wire [7:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .clk(clk),
        .duty_cycle(duty_cycle),
        .enable(enable),
        .vin(vin),
        .vout(vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            vin = 0;
            duty_cycle = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            enable = 1;
            vin = 8'd200;
            duty_cycle = 8'd255;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'd200);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            enable = 0;
            vin = 8'd200;
            duty_cycle = 8'd255;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            enable = 1;
            vin = 8'd200;
            duty_cycle = 8'd127;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'd99);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            enable = 1;
            vin = 8'd0;
            duty_cycle = 8'd255;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable = 1;
            vin = 8'd150;
            duty_cycle = 8'd51;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            enable = 1;
            vin = 8'd255;
            duty_cycle = 8'd128;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'd128);
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
        input [7:0] expected_vout;
        begin
            if (expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: vout=%h",
                         vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vout=%h",
                         expected_vout);
                $display("  Got:      vout=%h",
                         vout);
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
        $dumpvars(0,clk, duty_cycle, enable, vin, vout);
    end

endmodule

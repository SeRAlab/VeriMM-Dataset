`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vin;
    reg clk;
    reg enable;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .Vin(Vin),
        .clk(clk),
        .enable(enable),
        .Vout(Vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            Vin = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Basic enablement and regulation check");
            reset_dut();
            enable = 1;
            Vin = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Verify hold behavior when disabled");
            reset_dut();

            enable = 1;
            Vin = 8'h55;
            @(posedge clk);
            #1;

            enable = 0;
            Vin = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Dynamic input tracking while enabled");
            reset_dut();
            enable = 1;
            Vin = 8'h10;
            @(posedge clk);
            Vin = 8'h20;
            @(posedge clk);
            Vin = 8'h3E;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h3E);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Disable hold with multiple input changes");
            reset_dut();

            enable = 1;
            Vin = 8'h77;
            @(posedge clk);
            #1;

            enable = 0;
            @(posedge clk);

            Vin = 8'h11;
            @(posedge clk);
            Vin = 8'h22;
            @(posedge clk);
            Vin = 8'h33;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Re-enabling after hold");
            reset_dut();

            enable = 1;
            Vin = 8'hAA;
            @(posedge clk);
            enable = 0;
            Vin = 8'hBB;
            @(posedge clk);

            enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
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
        input [7:0] expected_Vout;
        begin
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h",
                         expected_Vout);
                $display("  Got:      Vout=%h",
                         Vout);
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
        $dumpvars(0,Vin, clk, enable, Vout);
    end

endmodule

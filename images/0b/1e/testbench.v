`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] Din;
    reg WE;
    reg clk;
    wire [3:0] Dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .Din(Din),
        .WE(WE),
        .clk(clk),
        .Dout(Dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            WE = 0;
            Din = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase %0d: Basic Write and Read (4'hA)", test_num);

            WE = 1;
            Din = 4'hA;
            @(posedge clk);
            #1;

            WE = 0;
            Din = 4'hF;
            #5;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase %0d: Verify WE=0 prevents writing", test_num);


            WE = 1;
            Din = 4'h5;
            @(posedge clk);
            #1;


            WE = 0;
            Din = 4'hC;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase %0d: Sequential Writes", test_num);

            WE = 1;
            Din = 4'h1;
            @(posedge clk);
            #1;

            Din = 4'h2;
            @(posedge clk);
            #1;

            Din = 4'h4;
            @(posedge clk);
            #1;

            Din = 4'h8;
            @(posedge clk);
            #1;

            WE = 0;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase %0d: Data Persistence across multiple cycles", test_num);

            WE = 1;
            Din = 4'hB;
            @(posedge clk);
            #1;

            WE = 0;
            Din = 4'h0;

            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase %0d: Boundary Values (4'h0 and 4'hF)", test_num);


            WE = 1;
            Din = 4'h0;
            @(posedge clk);
            #1;


            Din = 4'hF;
            @(posedge clk);
            #1;

            WE = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [3:0] expected_Dout;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h",
                         Dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h",
                         expected_Dout);
                $display("  Got:      Dout=%h",
                         Dout);
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
        $dumpvars(0,Din, WE, clk, Dout);
    end

endmodule

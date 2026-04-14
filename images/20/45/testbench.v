`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg RE;
    reg WE;
    reg clk;
    reg [3:0] din;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .din(din),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RE = 0;
            WE = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            WE = 1; din = 4'hA;
            @(posedge clk);
            #1;


            WE = 0; RE = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write and Read 4'h5", test_num);
            reset_dut();


            WE = 1; din = 4'h5;
            @(posedge clk);
            #1;


            WE = 0; RE = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Persistence check", test_num);
            reset_dut();


            WE = 1; din = 4'hF;
            @(posedge clk);
            #1;


            WE = 0; din = 4'h0;
            @(posedge clk);
            #1;


            RE = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overwriting data", test_num);
            reset_dut();


            WE = 1; din = 4'h3;
            @(posedge clk);
            #1;


            din = 4'hC;
            @(posedge clk);
            #1;


            WE = 0; RE = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Read Enable logic", test_num);
            reset_dut();


            WE = 1; din = 4'h7;
            @(posedge clk);
            #1;


            WE = 0; RE = 0;
            @(posedge clk);
            #1;


            RE = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input [3:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,RE, WE, clk, din, dout);
    end

endmodule

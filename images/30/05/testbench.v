`timescale 1ns/1ps

module SRAM_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D_in;
    reg RE;
    reg WE;
    reg [3:0] addr;
    reg clk;
    wire [15:0] D_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM dut (
        .D_in(D_in),
        .RE(RE),
        .WE(WE),
        .addr(addr),
        .clk(clk),
        .D_out(D_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D_in = 16'h0;
            RE = 0;
            WE = 0;
            addr = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read at Address 0", test_num);
            reset_dut();


            WE = 1;
            RE = 0;
            addr = 4'h0;
            D_in = 16'hAAAA;
            @(posedge clk);
            #1;


            WE = 0;
            RE = 1;
            addr = 4'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read at Address 15", test_num);
            reset_dut();


            WE = 1;
            RE = 0;
            addr = 4'hF;
            D_in = 16'h5555;
            @(posedge clk);
            #1;


            WE = 0;
            RE = 1;
            addr = 4'hF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify WE functionality (Write Disable)", test_num);
            reset_dut();


            WE = 1; addr = 4'h5; D_in = 16'h1234;
            @(posedge clk); #1;


            WE = 0; addr = 4'h5; D_in = 16'hFFFF;
            @(posedge clk); #1;


            RE = 1; addr = 4'h5;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Interference Check", test_num);
            reset_dut();


            WE = 1; addr = 4'h2; D_in = 16'h1111;
            @(posedge clk); #1;


            WE = 1; addr = 4'h3; D_in = 16'h2222;
            @(posedge clk); #1;


            WE = 0; RE = 1; addr = 4'h2;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Fill and Read", test_num);
            reset_dut();


            WE = 1;
            RE = 0;
            for (i = 0; i < 16; i = i + 1) begin
                addr = i;
                D_in = i;
                @(posedge clk);
                #1;
            end


            WE = 0;
            RE = 1;
            addr = 4'h7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0007);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify RE functionality (Read Disable)", test_num);
            reset_dut();


            WE = 1; addr = 4'hA; D_in = 16'hBEEF;
            @(posedge clk); #1;


            WE = 0; RE = 0; addr = 4'hA;
            @(posedge clk); #1;



            if (D_out !== 16'hBEEF) begin

                #1;


                check_outputs(D_out);
            end else begin
                $display("FAIL: D_out showing memory content while RE is low");
                fail_count = fail_count + 1;
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
        $display("SRAM Testbench");
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
        input [15:0] expected_D_out;
        begin
            if (expected_D_out === (expected_D_out ^ D_out ^ expected_D_out)) begin
                $display("PASS");
                $display("  Outputs: D_out=%h",
                         D_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_out=%h",
                         expected_D_out);
                $display("  Got:      D_out=%h",
                         D_out);
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
        $dumpvars(0,D_in, RE, WE, addr, clk, D_out);
    end

endmodule

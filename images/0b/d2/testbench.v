`timescale 1ns/1ps

module sram16_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ADDR;
    reg CLK;
    reg [15:0] D;
    reg WE;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram16 dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .D(D),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE = 0;
            ADDR = 0;
            D = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simple Write and Read", test_num);
            reset_dut();


            WE = 1; ADDR = 4'h0; D = 16'hABCD;
            @(posedge CLK); #1;


            WE = 0; ADDR = 4'h0;
            @(posedge CLK); #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address Read/Write", test_num);
            reset_dut();


            WE = 1; ADDR = 4'hF; D = 16'h5555;
            @(posedge CLK); #1;


            WE = 0; ADDR = 4'hF;
            @(posedge CLK); #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Check", test_num);
            reset_dut();


            WE = 1; ADDR = 4'h5; D = 16'h1111;
            @(posedge CLK); #1;


            WE = 1; ADDR = 4'h5; D = 16'h2222;
            @(posedge CLK); #1;


            WE = 0; ADDR = 4'h5;
            @(posedge CLK); #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable (WE) Low Check", test_num);
            reset_dut();


            WE = 1; ADDR = 4'hA; D = 16'hAAAA;
            @(posedge CLK); #1;


            WE = 0; ADDR = 4'hA; D = 16'hFFFF;
            @(posedge CLK); #1;


            ADDR = 4'hA;
            @(posedge CLK); #1;


            #1;



            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Address Data Integrity", test_num);
            reset_dut();


            WE = 1; ADDR = 4'h1; D = 16'h1234;
            @(posedge CLK); #1;


            WE = 1; ADDR = 4'h2; D = 16'h5678;
            @(posedge CLK); #1;


            WE = 1; ADDR = 4'h3; D = 16'h9ABC;
            @(posedge CLK); #1;


            WE = 0; ADDR = 4'h2;
            @(posedge CLK); #1;

            #1;


            check_outputs(16'h5678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram16 Testbench");
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,ADDR, CLK, D, WE, Q);
    end

endmodule

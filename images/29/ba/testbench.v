`timescale 1ns/1ps

module SRAM_8bit_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg [7:0] D;
    reg WE;
    reg [2:0] addr;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_8bit dut (
        .CE(CE),
        .D(D),
        .WE(WE),
        .addr(addr),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CE = 0;
        forever #5 CE = ~CE;
    end

        task reset_dut;

    begin
        WE = 1;
        addr = 3'b0;
        D = 8'h00;
        @(negedge CE);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read - Addr 0", test_num);
        reset_dut();


        WE = 0; addr = 3'd0; D = 8'hA5;
        @(negedge CE);


        WE = 1; addr = 3'd0;
        @(negedge CE);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read - Addr 7", test_num);
        reset_dut();


        WE = 0; addr = 3'd7; D = 8'h5A;
        @(negedge CE);


        WE = 1; addr = 3'd7;
        @(negedge CE);
        #1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite Address 3", test_num);
        reset_dut();


        WE = 0; addr = 3'd3; D = 8'h11;
        @(negedge CE);


        WE = 0; addr = 3'd3; D = 8'h22;
        @(negedge CE);


        WE = 1; addr = 3'd3;
        @(negedge CE);
        #1;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read when CE is High", test_num);
        reset_dut();


        WE = 0; addr = 3'd4; D = 8'hCC;
        @(negedge CE);


        WE = 1; addr = 3'd4;
        @(posedge CE);
        #1;
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address Isolation Check", test_num);
        reset_dut();


        WE = 0; addr = 3'd1; D = 8'h66;
        @(negedge CE);


        WE = 0; addr = 3'd2; D = 8'h77;
        @(negedge CE);


        WE = 1; addr = 3'd1;
        @(negedge CE);
        #1;
        #1;

        check_outputs(8'h66);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_8bit Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,CE, D, WE, addr, Q);
    end

endmodule

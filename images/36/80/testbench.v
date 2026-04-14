`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg RE;
    reg WE;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D <= 8'h00;
            RE <= 1'b0;
            WE <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read (8'hAA)", test_num);
            reset_dut();


            D <= 8'hAA;
            WE <= 1'b1;
            RE <= 1'b0;
            @(posedge clk);


            WE <= 1'b0;
            RE <= 1'b1;
            D <= 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read (8'h55)", test_num);
            reset_dut();


            D <= 8'h55;
            WE <= 1'b1;
            RE <= 1'b0;
            @(posedge clk);


            WE <= 1'b0;
            RE <= 1'b1;
            D <= 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Write Enable (WE=0 should not update)", test_num);
            reset_dut();


            D <= 8'h12;
            WE <= 1'b1;
            RE <= 1'b0;
            @(posedge clk);


            D <= 8'h99;
            WE <= 1'b0;
            @(posedge clk);


            RE <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Consecutive Writes", test_num);
            reset_dut();


            D <= 8'hDE;
            WE <= 1'b1;
            @(posedge clk);


            D <= 8'hAD;
            WE <= 1'b1;
            @(posedge clk);


            WE <= 1'b0;
            RE <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Persistence during RE toggling", test_num);
            reset_dut();


            D <= 8'hBC;
            WE <= 1'b1;
            RE <= 1'b0;
            @(posedge clk);


            WE <= 1'b0;
            RE <= 1'b0;
            @(posedge clk);


            RE <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hBC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        $dumpvars(0,D, RE, WE, clk, Q);
    end

endmodule

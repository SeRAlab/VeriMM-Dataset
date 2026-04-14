`timescale 1ns/1ps

module RAM4kx8_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] AB;
    reg CLK;
    reg CS;
    reg [7:0] DI;
    reg READ;
    wire [7:0] DO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RAM4kx8 dut (
        .AB(AB),
        .CLK(CLK),
        .CS(CS),
        .DI(DI),
        .READ(READ),
        .DO(DO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            @(negedge CLK);
            AB = 12'b0;
            CS = 1'b0;
            DI = 8'b0;
            READ = 1'b1;
            repeat (2) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read...");
            reset_dut();


            @(negedge CLK);
            CS = 1'b1;
            READ = 1'b0;
            AB = 12'h010;
            DI = 8'hA5;

            @(posedge CLK);


            @(negedge CLK);
            READ = 1'b1;

            @(posedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Chip Select Disable (Tri-state)...");
            reset_dut();


            @(negedge CLK);
            CS = 1'b1;
            READ = 1'b0;
            AB = 12'h200;
            DI = 8'h5A;
            @(posedge CLK);


            @(negedge CLK);
            CS = 1'b0;
            READ = 1'b1;
            AB = 12'h200;
            @(posedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(8'hZZ);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Boundary Address 0xFFF...");
            reset_dut();


            @(negedge CLK);
            CS = 1'b1;
            READ = 1'b0;
            AB = 12'hFFF;
            DI = 8'hFF;
            @(posedge CLK);


            @(negedge CLK);
            READ = 1'b1;
            @(posedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overwriting Memory...");
            reset_dut();


            @(negedge CLK);
            CS = 1'b1;
            READ = 1'b0;
            AB = 12'hABC;
            DI = 8'h11;
            @(posedge CLK);


            @(negedge CLK);
            DI = 8'h22;
            @(posedge CLK);


            @(negedge CLK);
            READ = 1'b1;
            @(posedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Address 0x000 and Toggle...");
            reset_dut();


            @(negedge CLK);
            CS = 1'b1;
            READ = 1'b0;
            AB = 12'h000;
            DI = 8'hCC;
            @(posedge CLK);


            @(negedge CLK);
            READ = 1'b1;
            @(posedge CLK);
            #1;

            test_num = test_num + 1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RAM4kx8 Testbench");
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
        input [7:0] expected_DO;
        begin
            if (expected_DO === (expected_DO ^ DO ^ expected_DO)) begin
                $display("PASS");
                $display("  Outputs: DO=%h",
                         DO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO=%h",
                         expected_DO);
                $display("  Got:      DO=%h",
                         DO);
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
        $dumpvars(0,AB, CLK, CS, DI, READ, DO);
    end

endmodule

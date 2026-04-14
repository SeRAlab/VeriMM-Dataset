`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg EN;
    reg RW;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .RW(RW),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 0;
            RW = 0;
            D = 8'h00;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();


            EN = 1;
            RW = 1;
            D = 8'hAA;
            @(posedge CLK);


            #1;
            RW = 0;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write with EN=0");
            reset_dut();


            EN = 1; RW = 1; D = 8'h55;
            @(posedge CLK);


            #1;
            EN = 0; RW = 1; D = 8'hFF;
            @(posedge CLK);


            #1;
            EN = 1; RW = 0;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Successive Writes");
            reset_dut();

            EN = 1; RW = 1; D = 8'h12;
            @(posedge CLK);
            #1;
            D = 8'h34;
            @(posedge CLK);
            #1;
            D = 8'h56;
            @(posedge CLK);


            #1;
            RW = 0;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'h56);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data stability during Read");
            reset_dut();


            EN = 1; RW = 1; D = 8'hBE;
            @(posedge CLK);


            #1;
            RW = 0;
            @(posedge CLK);
            #1;
            D = 8'h00;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary Values");
            reset_dut();


            EN = 1; RW = 1; D = 8'h00;
            @(posedge CLK);
            #1;
            RW = 0;
            @(posedge CLK);
            #1;
            if (Q !== 8'h00) begin
                #1;

                check_outputs(8'h00);
            end else begin

                RW = 1; D = 8'hFF;
                @(posedge CLK);
                #1;
                RW = 0;
                @(posedge CLK);
                #1;
                #1;

                check_outputs(8'hFF);
            end
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: EN=0 during Read behavior");
            reset_dut();


            EN = 1; RW = 1; D = 8'h77;
            @(posedge CLK);


            #1;
            EN = 0; RW = 0;
            @(posedge CLK);



            #1;
            EN = 1;
            RW = 0;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'h77);
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
        $dumpvars(0,CLK, D, EN, RW, Q);
    end

endmodule

`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] D;
    reg RE;
    reg WE;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .CLK(CLK),
        .D(D),
        .RE(RE),
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
            @(negedge CLK);
            RE = 0;
            WE = 0;
            D = 8'h00;
            test_num = test_num + 1;

            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Write 0xAA and Read back");


            @(negedge CLK);
            WE = 1;
            D = 8'hAA;
            @(posedge CLK);


            @(negedge CLK);
            WE = 0;
            RE = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Write 0x55, wait 2 cycles, then Read");


            @(negedge CLK);
            WE = 1;
            D = 8'h55;
            @(posedge CLK);


            @(negedge CLK);
            WE = 0;
            RE = 0;
            D = 8'hFF;
            repeat(2) @(posedge CLK);


            @(negedge CLK);
            RE = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Write 0x11, then overwrite with 0x22");


            @(negedge CLK);
            WE = 1;
            D = 8'h11;
            @(posedge CLK);


            @(negedge CLK);
            WE = 1;
            D = 8'h22;
            @(posedge CLK);


            @(negedge CLK);
            WE = 0;
            RE = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Write and Read 0x00 then 0xFF");


            @(negedge CLK);
            WE = 1; D = 8'h00;
            @(posedge CLK);


            @(negedge CLK);
            WE = 1; D = 8'hFF;
            @(posedge CLK);


            @(negedge CLK);
            WE = 0; RE = 1;
            @(posedge CLK);

            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        reg [7:0] prev_q;
        begin
            reset_dut();
            $display("Testcase 005: Verify Q does not update when RE=0");


            @(negedge CLK);
            WE = 1; D = 8'hA5;
            @(posedge CLK);
            @(negedge CLK);
            WE = 0; RE = 1;
            @(posedge CLK);
            #1;
            prev_q = Q;


            @(negedge CLK);
            RE = 0; WE = 1; D = 8'h5A;
            @(posedge CLK);


            @(negedge CLK);
            WE = 0; RE = 0;
            @(posedge CLK);

            #1;


            #1;



            check_outputs(prev_q);
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
        $dumpvars(0,CLK, D, RE, WE, Q);
    end

endmodule

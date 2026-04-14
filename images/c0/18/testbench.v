`timescale 1ns/1ps

module rf_dist_cm4_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] a;
    reg clk;
    reg [31:0] d;
    reg [6:0] dpra;
    reg we;
    wire [31:0] dpo;
    wire [31:0] spo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rf_dist_cm4 dut (
        .a(a),
        .clk(clk),
        .d(d),
        .dpra(dpra),
        .we(we),
        .dpo(dpo),
        .spo(spo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            d = 0;
            dpra = 0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            we = 1; a = 7'h05; d = 32'hDEADBEEF;
            @(posedge clk);
            #1 we = 0;


            a = 7'h05;
            dpra = 7'h05;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            we = 1; a = 7'h0A; d = 32'hAAAA_5555;
            @(posedge clk);

            #1 a = 7'h14; d = 32'h1234_5678;
            @(posedge clk);
            #1 we = 0;


            a = 7'h0A;
            dpra = 7'h14;
            #1;
            #1;

            check_outputs(32'h1234_5678, 32'hAAAA_5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            we = 1; a = 7'h30; d = 32'hFFFF_FFFF;
            @(posedge clk);
            #1 we = 0;


            a = 7'h30; d = 32'h0000_0000;
            @(posedge clk);
            #1;


            dpra = 7'h30;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            we = 1; a = 7'd127; d = 32'hCAFE_BABE;
            @(posedge clk);
            #1 we = 0;

            dpra = 7'd127;
            a = 7'd127;
            #1;
            #1;

            check_outputs(32'hCAFE_BABE, 32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            we = 1; a = 7'h40; d = 32'h1111_1111;
            @(posedge clk);


            #1 d = 32'h2222_2222;
            @(posedge clk);
            #1;

            dpra = 7'h00;
            #1;

            check_outputs(dpo, 32'h2222_2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rf_dist_cm4 Testbench");
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
        input [31:0] expected_dpo;
        input [31:0] expected_spo;
        begin
            if (expected_dpo === (expected_dpo ^ dpo ^ expected_dpo) &&
                expected_spo === (expected_spo ^ spo ^ expected_spo)) begin
                $display("PASS");
                $display("  Outputs: dpo=%h, spo=%h",
                         dpo, spo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dpo=%h, spo=%h",
                         expected_dpo, expected_spo);
                $display("  Got:      dpo=%h, spo=%h",
                         dpo, spo);
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
        $dumpvars(0,a, clk, d, dpra, we, dpo, spo);
    end

endmodule

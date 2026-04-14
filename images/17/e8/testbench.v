`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RE;
    reg WE;
    reg clk;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
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
            D <= 0;
            RE <= 0;
            WE <= 1;
            @(posedge clk);
            WE <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 1 then Read 1", test_num);
            reset_dut();


            @(posedge clk);
            D <= 1'b1;
            WE <= 1'b1;
            RE <= 1'b0;


            @(posedge clk);
            WE <= 1'b0;


            RE <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write 0 then Read 0", test_num);
            reset_dut();


            @(posedge clk);
            D <= 1'b1;
            WE <= 1'b1;
            @(posedge clk);


            D <= 1'b0;
            WE <= 1'b1;
            RE <= 1'b0;
            @(posedge clk);
            WE <= 1'b0;


            RE <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence Test", test_num);
            reset_dut();


            @(posedge clk);
            D <= 1'b1;
            WE <= 1'b1;
            @(posedge clk);


            WE <= 1'b0;
            RE <= 1'b0;
            D <= 1'b0;
            repeat(3) @(posedge clk);


            RE <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Inhibit Test", test_num);
            reset_dut();


            @(posedge clk);
            D <= 1'b1;
            WE <= 1'b0;
            RE <= 1'b0;
            @(posedge clk);


            RE <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Enable Control Test", test_num);
            reset_dut();


            @(posedge clk);
            D <= 1'b1;
            WE <= 1'b1;
            @(posedge clk);
            WE <= 1'b0;


            RE <= 1'b0;
            @(posedge clk);
            #1;

            if (Q === 1'b0 || Q === 1'bz) begin

                RE <= 1'b1;
                @(posedge clk);
                #1;
                #1;

                check_outputs(1'b1);
            end else begin

                $display("FAIL: Q is driving data while RE is low");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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

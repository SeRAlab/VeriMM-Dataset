`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] addra;
    reg clka;
    reg [11:0] dina;
    reg wea;
    wire [11:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .dina(dina),
        .wea(wea),
        .douta(douta)
    );

    // Clock generation (10ns period)
    initial begin
        clka = 0;
        forever #5 clka = ~clka;
    end

        task reset_dut;

        begin
            addra = 15'h0;
            dina = 12'h0;
            wea = 1'b0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            addra = 15'h0010;
            dina = 12'hA5A;
            wea = 1'b1;
            @(posedge clka);
            #1;


            wea = 1'b0;
            addra = 15'h0000;
            @(posedge clka);
            #1;


            addra = 15'h0010;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hA5A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Verify Write Enable (wea=0)", test_num);


            addra = 15'h0020;
            dina = 12'h111;
            wea = 1'b1;
            @(posedge clka);
            #1;


            addra = 15'h0020;
            dina = 12'hEEE;
            wea = 1'b0;
            @(posedge clka);
            #1;


            addra = 15'h0020;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Boundary Address (0x7FFF)", test_num);


            addra = 15'h7FFF;
            dina = 12'hFFF;
            wea = 1'b1;
            @(posedge clka);
            #1;


            wea = 1'b0;
            addra = 15'h7FFF;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overwrite Data", test_num);


            addra = 15'h1234;
            dina = 12'hAAA;
            wea = 1'b1;
            @(posedge clka);
            #1;


            addra = 15'h1234;
            dina = 12'h555;
            wea = 1'b1;
            @(posedge clka);
            #1;


            wea = 1'b0;
            addra = 15'h1234;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Consecutive Access", test_num);


            addra = 15'h0001; dina = 12'h101; wea = 1'b1;
            @(posedge clka); #1;

            addra = 15'h0002; dina = 12'h202; wea = 1'b1;
            @(posedge clka); #1;

            addra = 15'h0003; dina = 12'h303; wea = 1'b1;
            @(posedge clka); #1;


            wea = 1'b0;
            addra = 15'h0002;
            @(posedge clka); #1;
            #1;

            check_outputs(12'h202);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [11:0] expected_douta;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta)) begin
                $display("PASS");
                $display("  Outputs: douta=%h",
                         douta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%h",
                         expected_douta);
                $display("  Got:      douta=%h",
                         douta);
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
        $dumpvars(0,addra, clka, dina, wea, douta);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addra;
    reg clka;
    reg [15:0] dina;
    reg ena;
    reg wea;
    wire [15:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .clka(clka),
        .dina(dina),
        .ena(ena),
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
        ena = 0;
        wea = 0;
        addra = 0;
        dina = 0;
        @(posedge clka);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        @(negedge clka);
        ena = 1;
        wea = 1;
        addra = 12'h001;
        dina = 16'hABCD;
        @(posedge clka);


        @(negedge clka);
        wea = 0;
        @(posedge clka);

        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Address (0xFFF) Write/Read", test_num);
        reset_dut();


        @(negedge clka);
        ena = 1;
        wea = 1;
        addra = 12'hFFF;
        dina = 16'h55AA;
        @(posedge clka);


        @(negedge clka);
        wea = 0;
        @(posedge clka);

        #1;
        #1;

        check_outputs(16'h55AA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable (ena) Signal Check", test_num);
        reset_dut();


        @(negedge clka);
        ena = 1; wea = 1; addra = 12'h100; dina = 16'h1111;
        @(posedge clka);


        @(negedge clka);
        ena = 0; wea = 1; addra = 12'h100; dina = 16'hEEEE;
        @(posedge clka);


        @(negedge clka);
        ena = 1; wea = 0; addra = 12'h100;
        @(posedge clka);

        #1;

        #1;


        check_outputs(16'h1111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite Data Test", test_num);
        reset_dut();


        @(negedge clka);
        ena = 1; wea = 1; addra = 12'h200; dina = 16'hAAAA;
        @(posedge clka);


        @(negedge clka);
        dina = 16'hBBBB;
        @(posedge clka);


        @(negedge clka);
        wea = 0;
        @(posedge clka);

        #1;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read-only Mode Check", test_num);
        reset_dut();


        @(negedge clka);
        ena = 1; wea = 1; addra = 12'h300; dina = 16'h7777;
        @(posedge clka);


        @(negedge clka);
        wea = 0; dina = 16'hFFFF;
        @(posedge clka);

        #1;

        #1;


        check_outputs(16'h7777);
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
        input [15:0] expected_douta;
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
        $dumpvars(0,addra, clka, dina, ena, wea, douta);
    end

endmodule

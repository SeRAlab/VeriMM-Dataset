`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addra;
    reg clka;
    reg dina;
    reg wea;
    wire douta;

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
            addra = 14'b0;
            dina = 1'b0;
            wea = 1'b0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write/Read at Address 0", test_num);


            wea = 1;
            addra = 14'h0000;
            dina = 1'b1;
            @(posedge clka);
            #1;


            wea = 0;
            @(posedge clka);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write/Read at Max Address (14'h3FFF)", test_num);


            wea = 1;
            addra = 14'h3FFF;
            dina = 1'b1;
            @(posedge clka);
            #1;


            wea = 0;
            @(posedge clka);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwriting data", test_num);


            wea = 1;
            addra = 14'h0ABC;
            dina = 1'b1;
            @(posedge clka);
            #1;


            dina = 1'b0;
            @(posedge clka);
            #1;


            wea = 0;
            @(posedge clka);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Verify Write Enable (wea) low prevents writing", test_num);


            wea = 1;
            addra = 14'h1234;
            dina = 1'b0;
            @(posedge clka);
            #1;


            wea = 0;
            dina = 1'b1;
            @(posedge clka);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Persistence check across addresses", test_num);


            wea = 1;
            addra = 14'h0001;
            dina = 1'b1;
            @(posedge clka);
            #1;


            addra = 14'h0002;
            dina = 1'b0;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 14'h0001;
            @(posedge clka);
            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_douta;
        begin
            if (expected_douta === (expected_douta ^ douta ^ expected_douta)) begin
                $display("PASS");
                $display("  Outputs: douta=%b",
                         douta);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: douta=%b",
                         expected_douta);
                $display("  Got:      douta=%b",
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

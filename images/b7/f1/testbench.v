`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addra;
    reg clka;
    reg [7:0] dina;
    reg wea;
    wire [7:0] douta;

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
            wea = 0;
            addra = 0;
            dina = 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read back", test_num);
            reset_dut();


            wea = 1;
            addra = 10'd10;
            dina = 8'hA5;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 10'd10;
            @(posedge clka);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address 1023", test_num);
            reset_dut();


            wea = 1;
            addra = 10'd1023;
            dina = 8'hFF;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 10'd1023;
            @(posedge clka);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data", test_num);
            reset_dut();


            wea = 1;
            addra = 10'd50;
            dina = 8'h11;
            @(posedge clka);
            #1;


            wea = 1;
            addra = 10'd50;
            dina = 8'h22;
            @(posedge clka);
            #1;


            wea = 0;
            @(posedge clka);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Validation", test_num);
            reset_dut();


            wea = 1;
            addra = 10'd100;
            dina = 8'hCC;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 10'd100;
            dina = 8'hEE;
            @(posedge clka);
            #1;


            addra = 10'd100;
            @(posedge clka);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Sequential Accesses", test_num);
            reset_dut();


            wea = 1; addra = 10'd1; dina = 8'h01; @(posedge clka); #1;

            wea = 1; addra = 10'd2; dina = 8'h02; @(posedge clka); #1;


            wea = 0; addra = 10'd1; @(posedge clka); #1;

            addra = 10'd2; @(posedge clka); #1;


            #1;



            check_outputs(8'h02);
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
        input [7:0] expected_douta;
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

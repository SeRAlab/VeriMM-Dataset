`timescale 1ns/1ps

module lut_mem_block_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addra;
    reg clka;
    reg [3:0] dina;
    reg ena;
    wire [3:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lut_mem_block dut (
        .addra(addra),
        .clka(clka),
        .dina(dina),
        .ena(ena),
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
            addra = 0;
            dina = 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            ena = 1;
            addra = 4'h5;
            dina = 4'hA;
            @(posedge clka);
            #1;


            ena = 0;
            addra = 4'h5;
            #5;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Boundary Address Write/Read", test_num);
            reset_dut();


            ena = 1;
            addra = 4'hF;
            dina = 4'h7;
            @(posedge clka);
            #1;


            ena = 0;
            addra = 4'hF;
            #5;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Address 0 Write/Read", test_num);
            reset_dut();


            ena = 1;
            addra = 4'h0;
            dina = 4'hE;
            @(posedge clka);
            #1;


            ena = 0;
            addra = 4'h0;
            #5;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Verify Write Enable logic", test_num);
            reset_dut();


            ena = 1;
            addra = 4'h7;
            dina = 4'hB;
            @(posedge clka);
            #1;


            ena = 0;
            addra = 4'h7;
            dina = 4'hC;
            @(posedge clka);
            #1;


            addra = 4'h7;
            #5;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Overwriting data", test_num);
            reset_dut();


            ena = 1; addra = 4'h2; dina = 4'h1;
            @(posedge clka); #1;


            ena = 1; addra = 4'h2; dina = 4'h9;
            @(posedge clka); #1;


            ena = 0; addra = 4'h2;
            #5;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple address writes", test_num);
            reset_dut();

            ena = 1; addra = 4'h1; dina = 4'h2; @(posedge clka); #1;
            ena = 1; addra = 4'h2; dina = 4'h4; @(posedge clka); #1;
            ena = 1; addra = 4'h3; dina = 4'h6; @(posedge clka); #1;
            ena = 1; addra = 4'h4; dina = 4'h8; @(posedge clka); #1;


            ena = 0;
            addra = 4'h3;
            #5;
            #1;

            check_outputs(4'h6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lut_mem_block Testbench");
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
        input [3:0] expected_douta;
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
        $dumpvars(0,addra, clka, dina, ena, douta);
    end

endmodule

`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] addra;
    reg clka;
    reg [2:0] dina;
    reg wea;
    wire [2:0] douta;

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
            @(negedge clka);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(negedge clka);
            wea = 1;
            addra = 13'h0000;
            dina = 3'b101;
            @(negedge clka);

            wea = 0;
            addra = 13'h0000;
            @(posedge clka);
            #1;
            $display("Test 001: Write/Read at Addr 0");
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(negedge clka);
            wea = 1;
            addra = 13'h1FFF;
            dina = 3'b011;
            @(negedge clka);

            wea = 0;
            addra = 13'h1FFF;
            @(posedge clka);
            #1;
            $display("Test 002: Write/Read at Max Addr (8191)");
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            @(negedge clka);
            wea = 1;
            addra = 13'd100;
            dina = 3'b111;
            @(negedge clka);

            wea = 1;
            addra = 13'd200;
            dina = 3'b000;
            @(negedge clka);

            wea = 0;
            addra = 13'd100;
            @(posedge clka);
            #1;
            $display("Test 003: Address Independence (Read Addr 100)");
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clka);
            wea = 1;
            addra = 13'd555;
            dina = 3'b010;
            @(negedge clka);

            wea = 1;
            addra = 13'd555;
            dina = 3'b110;
            @(negedge clka);

            wea = 0;
            addra = 13'd555;
            @(posedge clka);
            #1;
            $display("Test 004: Overwriting Data at Addr 555");
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clka);
            wea = 1;
            addra = 13'h0ABC;
            dina = 3'b111;
            @(negedge clka);

            wea = 0;
            addra = 13'h0ABC;
            @(posedge clka);
            #1;
            $display("Test 005: Data Pattern 111");
            #1;

            check_outputs(3'b111);
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
        input [2:0] expected_douta;
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

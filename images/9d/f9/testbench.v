`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addra;
    reg clka;
    reg [31:0] dina;
    reg wea;
    wire [31:0] douta;

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
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write and Read at address 0", test_num);


            wea = 1;
            addra = 7'h00;
            dina = 32'hDEADBEEF;
            @(posedge clka);
            #1;


            wea = 0;
            @(posedge clka);
            #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write and Read at maximum address (127)", test_num);


            wea = 1;
            addra = 7'h7F;
            dina = 32'h12345678;
            @(posedge clka);
            #1;


            wea = 0;
            @(posedge clka);
            #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Verify no write occurs when wea=0", test_num);


            wea = 1;
            addra = 7'h05;
            dina = 32'hAAAA_AAAA;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 7'h05;
            dina = 32'h5555_5555;
            @(posedge clka);
            #1;


            addra = 7'h05;
            @(posedge clka);
            #1;

            #1;


            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Sequential writes to multiple addresses", test_num);


            wea = 1; addra = 7'h0A; dina = 32'hC0DE_0001;
            @(posedge clka); #1;


            wea = 1; addra = 7'h0B; dina = 32'hC0DE_0002;
            @(posedge clka); #1;


            wea = 0; addra = 7'h0A;
            @(posedge clka); #1;

            #1;


            check_outputs(32'hC0DE_0001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Overwriting an existing memory location", test_num);


            wea = 1; addra = 7'h20; dina = 32'h1111_1111;
            @(posedge clka); #1;


            wea = 1; addra = 7'h20; dina = 32'h2222_2222;
            @(posedge clka); #1;


            wea = 0; addra = 7'h20;
            @(posedge clka); #1;

            #1;


            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Check address independence (Crosstalk test)", test_num);


            wea = 1; addra = 7'h40; dina = 32'h6464_6464;
            @(posedge clka); #1;


            wea = 1; addra = 7'h41; dina = 32'h6565_6565;
            @(posedge clka); #1;


            wea = 0; addra = 7'h40;
            @(posedge clka); #1;

            #1;


            check_outputs(32'h6464_6464);
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
        input [31:0] expected_douta;
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

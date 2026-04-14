`timescale 1ns/1ps

module block_mem_generator_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addra;
    reg clka;
    reg [11:0] dina;
    reg wea;
    wire [11:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    block_mem_generator dut (
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
            addra = 0;
            dina = 0;
            wea = 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);


            wea = 1;
            addra = 14'h0000;
            dina = 12'hABC;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 14'h0000;
            @(posedge clka);
            #2;

            #1;


            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write and Read at Max Address", test_num);


            wea = 1;
            addra = 14'h3FFF;
            dina = 12'hFFF;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 14'h3FFF;
            @(posedge clka);
            #2;

            #1;


            check_outputs(12'hFFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwrite Data at Address 0x123", test_num);


            wea = 1;
            addra = 14'h0123;
            dina = 12'h555;
            @(posedge clka);
            #1;


            wea = 1;
            addra = 14'h0123;
            dina = 12'hAAA;
            @(posedge clka);
            #1;


            wea = 0;
            addra = 14'h0123;
            @(posedge clka);
            #2;

            #1;


            check_outputs(12'hAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Multiple Address Independence Check", test_num);


            wea = 1; addra = 14'h0010; dina = 12'h111;
            @(posedge clka); #1;


            wea = 1; addra = 14'h0020; dina = 12'h222;
            @(posedge clka); #1;


            wea = 0; addra = 14'h0010;
            @(posedge clka); #2;

            #1;


            check_outputs(12'h111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Verify Write Enable (wea=0 should not write)", test_num);


            wea = 1; addra = 14'h0050; dina = 12'h777;
            @(posedge clka); #1;


            wea = 0; addra = 14'h0050; dina = 12'h888;
            @(posedge clka); #1;


            wea = 0; addra = 14'h0050;
            @(posedge clka); #2;

            #1;


            check_outputs(12'h777);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("block_mem_generator Testbench");
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

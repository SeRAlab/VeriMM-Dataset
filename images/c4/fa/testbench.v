`timescale 1ns/1ps

module memory_interface_tb;

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
    memory_interface dut (
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
            wea <= 0;
            addra <= 0;
            dina <= 0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Reading uninitialized memory", test_num);
            addra <= 14'h0A2C;
            wea <= 0;
            @(posedge clka);
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Simple Write then Read back", test_num);

            addra <= 14'h0005;
            dina <= 12'hABC;
            wea <= 1;
            @(posedge clka);

            wea <= 0;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Boundary Address Check (0x3FFF)", test_num);

            addra <= 14'h3FFF;
            dina <= 12'hFFF;
            wea <= 1;
            @(posedge clka);

            wea <= 0;
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
            $display("Testcase %0d: Overwriting memory location", test_num);

            addra <= 14'h0100;
            dina <= 12'h111;
            wea <= 1;
            @(posedge clka);

            dina <= 12'h222;
            wea <= 1;
            @(posedge clka);

            wea <= 0;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Verify Write Enable (wea=0 prevents write)", test_num);

            addra <= 14'h0050;
            dina <= 12'h777;
            wea <= 1;
            @(posedge clka);

            dina <= 12'h888;
            wea <= 0;
            @(posedge clka);

            addra <= 14'h0050;
            wea <= 0;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h777);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Verify memory address isolation", test_num);

            addra <= 14'h0010;
            dina <= 12'hAAA;
            wea <= 1;
            @(posedge clka);

            addra <= 14'h0011;
            dina <= 12'hBBB;
            wea <= 1;
            @(posedge clka);

            addra <= 14'h0010;
            wea <= 0;
            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_interface Testbench");
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

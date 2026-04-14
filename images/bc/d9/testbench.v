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
            reset_dut();
            test_num = 1;
            $display("Test %0d: Basic Write and Read", test_num);


            wea = 1;
            addra = 10'h001;
            dina = 8'hA5;
            @(posedge clka);


            #1;
            wea = 0;
            addra = 10'h001;


            #5;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Boundary Address (0x3FF)", test_num);


            wea = 1;
            addra = 10'h3FF;
            dina = 8'h5A;
            @(posedge clka);


            #1;
            wea = 0;
            addra = 10'h3FF;

            #5;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Write Enable (WEA) Verification", test_num);


            wea = 1;
            addra = 10'h010;
            dina = 8'hCC;
            @(posedge clka);


            #1;
            wea = 0;
            addra = 10'h010;
            dina = 8'hFF;
            @(posedge clka);


            #1;
            addra = 10'h010;

            #5;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Multiple Address Writing", test_num);


            wea = 1; addra = 10'h005; dina = 8'h11;
            @(posedge clka);


            #1;
            addra = 10'h006; dina = 8'h22;
            @(posedge clka);


            #1;
            wea = 0;
            addra = 10'h005;

            #5;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Data Pattern 0xFF and 0x00", test_num);


            wea = 1; addra = 10'h020; dina = 8'hFF;
            @(posedge clka);


            #1;
            addra = 10'h021; dina = 8'h00;
            @(posedge clka);


            #1;
            wea = 0;
            addra = 10'h021;

            #5;
            #1;

            check_outputs(8'h00);
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

`timescale 1ns/1ps

module memory_block_generator_tb;

    // Testbench signals (sequential circuit)
    reg [8191:0] addra;
    reg clka;
    reg [12:0] dina;
    reg ena;
    reg wea;
    wire [12:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_block_generator dut (
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
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1;
            wea = 1;
            addra = 13'h0000;
            dina = 13'h1ABC;

            @(posedge clka);

            wea = 0;

            @(posedge clka);
            #1;
            #1;

            check_outputs(13'h1ABC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Address Test (Addr 8191)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1;
            wea = 1;
            addra = 13'h1FFF;
            dina = 13'h0FFF;

            @(posedge clka);

            wea = 0;

            @(posedge clka);
            #1;
            #1;

            check_outputs(13'h0FFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Control (ena=0)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 13'h0010; dina = 13'h0AAA;


            @(posedge clka);
            ena = 0; wea = 1; addra = 13'h0010; dina = 13'h0555;


            @(posedge clka);
            ena = 1; wea = 0; addra = 13'h0010;

            @(posedge clka);
            #1;
            #1;

            check_outputs(13'h0AAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Control (wea=0)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 13'h0020; dina = 13'h0777;


            @(posedge clka);
            ena = 1; wea = 0; addra = 13'h0020; dina = 13'h0000;


            @(posedge clka);
            ena = 1; wea = 0; addra = 13'h0020;

            @(posedge clka);
            #1;
            #1;

            check_outputs(13'h0777);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Enable Control (ena=0 blocks output)", test_num);
            reset_dut();


            @(posedge clka);
            ena = 1; wea = 1; addra = 13'h01; dina = 13'h1111;
            @(posedge clka);
            ena = 1; wea = 1; addra = 13'h02; dina = 13'h2222;


            @(posedge clka);
            ena = 1; wea = 0; addra = 13'h01;
            @(posedge clka);
            #1;


            @(posedge clka);
            ena = 0; wea = 0; addra = 13'h02;

            @(posedge clka);
            #1;



            #1;




            check_outputs(13'h1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_block_generator Testbench");
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
        input [12:0] expected_douta;
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

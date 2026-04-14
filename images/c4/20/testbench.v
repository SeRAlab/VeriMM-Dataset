`timescale 1ns/1ps

module memory_generator_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] addra;
    reg clka;
    reg [11:0] dina;
    reg wea;
    wire [11:0] douta;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_generator dut (
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
            addra = 15'd0;
            dina = 12'd0;
            wea = 1'b0;
            @(posedge clka);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase %03d: Basic Write/Read", test_num);


            @(posedge clka);
            wea = 1'b1;
            addra = 15'h0000;
            dina = 12'hABC;


            @(posedge clka);
            wea = 1'b0;


            @(posedge clka);
            addra = 15'h0000;


            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase %03d: Boundary Address Write/Read", test_num);


            @(posedge clka);
            wea = 1'b1;
            addra = 15'd16383;
            dina = 12'hF0F;

            @(posedge clka);
            wea = 1'b0;
            addra = 15'd16383;


            @(posedge clka);
            #1;
            #1;

            check_outputs(12'hF0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase %03d: Write Enable Verification", test_num);


            @(posedge clka);
            wea = 1'b1;
            addra = 15'h0123;
            dina = 12'h555;


            @(posedge clka);
            wea = 1'b0;
            addra = 15'h0123;
            dina = 12'hAAA;


            @(posedge clka);
            addra = 15'h0123;

            @(posedge clka);
            #1;

            #1;


            check_outputs(12'h555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase %03d: Overwrite Verification", test_num);


            @(posedge clka);
            wea = 1'b1;
            addra = 15'h00A5;
            dina = 12'h111;


            @(posedge clka);
            wea = 1'b1;
            addra = 15'h00A5;
            dina = 12'h222;

            @(posedge clka);
            wea = 1'b0;
            addra = 15'h00A5;

            @(posedge clka);
            #1;
            #1;

            check_outputs(12'h222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Running Testcase %03d: Sequential Access", test_num);


            @(posedge clka);
            wea = 1'b1; addra = 15'd10; dina = 12'hA0A;

            @(posedge clka);
            wea = 1'b1; addra = 15'd20; dina = 12'hB0B;


            @(posedge clka);
            wea = 1'b0; addra = 15'd10;
            @(posedge clka);

            addra = 15'd20;
            @(posedge clka);
            #1;

            #1;


            check_outputs(12'hB0B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("memory_generator Testbench");
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

`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg RE;
    reg WE;
    reg clk;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            D = 8'h00;
            RE = 1'b0;
            WE = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);


            D = 8'hA5;
            WE = 1'b1;
            RE = 1'b0;
            @(posedge clk);
            #1;


            WE = 1'b0;
            RE = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Inhibit Test", test_num);


            D = 8'h3C;
            WE = 1'b0;
            RE = 1'b0;
            @(posedge clk);
            #1;


            RE = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence Test", test_num);


            D = 8'h77;
            WE = 1'b1;
            RE = 1'b0;
            @(posedge clk);
            #1;


            WE = 1'b0;
            D = 8'hFF;
            @(posedge clk);
            #1;


            RE = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Read Enable High-Z/Low Test", test_num);


            D = 8'hAA;
            WE = 1'b1;
            RE = 1'b0;
            @(posedge clk);
            #1;


            WE = 1'b0;
            RE = 1'b0;
            @(posedge clk);
            #1;





            #1;






            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Data Overwrite Test", test_num);


            D = 8'h11;
            WE = 1'b1;
            @(posedge clk);
            #1;


            D = 8'h22;
            WE = 1'b1;
            @(posedge clk);
            #1;


            WE = 1'b0;
            RE = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);


            D = 8'hF0;
            WE = 1'b1;
            RE = 1'b1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'hF0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eeprom_cell Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, RE, WE, clk, Q);
    end

endmodule

`timescale 1ns/1ps

module ram_8bit_16word_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ADDR;
    reg CLK;
    reg [7:0] DATA_IN;
    reg RE;
    reg WE;
    wire [7:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ram_8bit_16word dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .RE(RE),
        .WE(WE),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            ADDR = 4'h0;
            DATA_IN = 8'h0;
            WE = 0;
            RE = 0;

            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            ADDR = 4'h5;
            DATA_IN = 8'hAA;
            WE = 1;
            RE = 0;
            @(posedge CLK);
            #1;


            WE = 0;
            RE = 0;
            @(posedge CLK);
            #1;


            ADDR = 4'h5;
            WE = 0;
            RE = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Data", test_num);
            reset_dut();


            ADDR = 4'hA; DATA_IN = 8'h11; WE = 1; RE = 0;
            @(posedge CLK); #1;


            DATA_IN = 8'h22;
            @(posedge CLK); #1;


            WE = 0; RE = 1;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Address Writing", test_num);
            reset_dut();


            ADDR = 4'h1; DATA_IN = 8'hD1; WE = 1; @(posedge CLK); #1;
            ADDR = 4'h2; DATA_IN = 8'hD2; WE = 1; @(posedge CLK); #1;
            ADDR = 4'h3; DATA_IN = 8'hD3; WE = 1; @(posedge CLK); #1;


            WE = 0; RE = 1; ADDR = 4'h2;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'hD2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read Enable Verification", test_num);
            reset_dut();


            ADDR = 4'hC; DATA_IN = 8'hCC; WE = 1; RE = 0;
            @(posedge CLK); #1;


            ADDR = 4'h5; WE = 0; RE = 1;
            @(posedge CLK); #1;



            ADDR = 4'hC; RE = 0;
            @(posedge CLK); #1;


            RE = 1;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address (0xF)", test_num);
            reset_dut();

            ADDR = 4'hF; DATA_IN = 8'hFF; WE = 1; RE = 0;
            @(posedge CLK); #1;

            WE = 0; RE = 1;
            @(posedge CLK); #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Write and Read", test_num);
            reset_dut();



            ADDR = 4'h7; DATA_IN = 8'h77; WE = 1; RE = 1;
            @(posedge CLK); #1;




            #1;





            check_outputs(8'h77);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ram_8bit_16word Testbench");
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
        input [7:0] expected_DATA_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
        $dumpvars(0,ADDR, CLK, DATA_IN, RE, WE, DATA_OUT);
    end

endmodule

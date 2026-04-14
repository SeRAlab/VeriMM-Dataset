`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg Serial_in;
    wire [7:0] Data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .CLK(CLK),
        .RST(RST),
        .Serial_in(Serial_in),
        .Data_out(Data_out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            Serial_in = 0;
            #15;
            RST = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Single High Bit", test_num);
            reset_dut();
            @(negedge CLK);
            Serial_in = 1;
            @(negedge CLK);
            Serial_in = 0;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Alternating Pattern (0x55)", test_num);
            reset_dut();
            pattern = 8'b10101010;

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge CLK);
                Serial_in = (pattern >> i) & 1'b1;
            end

            @(negedge CLK);



            #1;




            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Register (0xFF)", test_num);
            reset_dut();
            @(negedge CLK);
            Serial_in = 1;
            repeat (8) @(negedge CLK);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Through (Overflow)", test_num);
            reset_dut();


            @(negedge CLK);
            Serial_in = 1;
            repeat (8) @(negedge CLK);


            Serial_in = 0;
            repeat (4) @(negedge CLK);


            #1;



            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Pattern 0xAC", test_num);
            reset_dut();

            @(negedge CLK); Serial_in = 0;
            @(negedge CLK); Serial_in = 0;
            @(negedge CLK); Serial_in = 1;
            @(negedge CLK); Serial_in = 1;
            @(negedge CLK); Serial_in = 0;
            @(negedge CLK); Serial_in = 1;
            @(negedge CLK); Serial_in = 0;
            @(negedge CLK); Serial_in = 1;
            @(negedge CLK);

            #1;


            check_outputs(8'hAC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_Data_out;
        begin
            if (expected_Data_out === (expected_Data_out ^ Data_out ^ expected_Data_out)) begin
                $display("PASS");
                $display("  Outputs: Data_out=%h",
                         Data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out=%h",
                         expected_Data_out);
                $display("  Got:      Data_out=%h",
                         Data_out);
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
        $dumpvars(0,CLK, RST, Serial_in, Data_out);
    end

endmodule
